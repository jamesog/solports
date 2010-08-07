#!/usr/bin/perl -w

# Scan a directory tree and output manifest information that can be passed
# to pkgsend include
#
# Currently this just detects directories, files, hardlinks and symlinks.

use strict;
use File::Spec;

my $dir = shift || die "usage: $0 dir\n";

if ($dir =~ m{^/}) {
    $dir =~ s{^/}{};
    chdir "/";
}

# Calculate the relative path from src to dst
# File::Spec->abs2rel($dstfile, $srcdir)
sub relativepath {
    my (@src) = File::Spec->splitdir(shift);
    my $dstfile = shift;
    pop @src;
    my $srcdir = File::Spec->catdir(@src);
    return File::Spec->abs2rel($dstfile, $srcdir);
}

my @dirs;
my @files;
my @links;
my @symlinks;

# Core directories - ideally we should depend on some package
# that provides these, but that package doesn't exist right now.
# Until then just make sure they are root:sys instead of root:bin
my %coredir;
foreach my $f qw(usr usr/share usr/gnu/share opt etc) { $coredir{$f} = 1; }
open FIND, "find -H $dir -type d -print|";
while (<FIND>) {
    chomp;
    if (exists $coredir{$_}) {
	push @dirs, "dir mode=0755 owner=root group=sys path=$_";
    } else {
	push @dirs, "dir mode=0755 owner=root group=bin path=$_";
    }
}
close FIND or die "$0: error running find:$!";

# Indexed by inode, this lets us detect and recreate hard linked files
my %installed;
open FIND, "find -H $dir -type f -print|";
while (<FIND>) {
    chomp;
    next if  m{(^|/)(\.packlist|perllocal.pod)$};
    my ($inode) = (stat $_)[1];
    if (exists $installed{$inode}) {
	my $target = relativepath($_, $installed{$inode});
	push @links, "hardlink path=$_ target=$target";
    } else {
	my $mode = '0444';
	if (-x $_) {
	    $mode = '0555';
	} else {
	    # There must be a better way than running file(1)
	    my $t = `file $_`;
	    $mode = '0555' if $t =~ m{:\tELF};
	}
	push @files, "file $_ mode=$mode owner=root group=bin path=$_";
	$installed{$inode} = $_;
    }
}
close FIND or die "$0: error running find:$!";

open FIND, "find -H $dir -type l -print|";
while (<FIND>) {
    chomp;
    my $target = relativepath($_, readlink $_);
    push @symlinks, "link path=$_ target=$target";
}
close FIND or die "$0: error running find:$!";

# TODO: look for other installable things

print join "\n", @dirs, (sort @files), (sort @links), (sort @symlinks), '';
