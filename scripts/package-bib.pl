#!/usr/bin/env perl
# scripts/package-bib.pl -*-perl-*-
#
# Script to generate bib entries from a file with one package name per line
# using ctanbib.
#
# Copyright (c) 2024 Marcel Ilg
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

use v5.36;

use Path::Tiny;

sub generate_pkg_array(@filenames)
{
  # return value
  my @ret = ();

  for my $filename (@filenames) {
    my $filepath = path($filename);
    if (!$filepath->exists) {
      say STDERR "File $filepath does not exist!";
      die "File $filepath does not exist!";
    }

    if (!$filepath->is_file) {
      say STDERR "File $filepath is not a file!";
      die "File $filepath is not a file!";
    }

    push(@ret, ($filepath->lines({chomp => 1})));
  }
  return @ret;
}

# command for ctanbib
my $ctanbib_cmd = 'ctanbib';

# ctanbib options
my @ctanbib_opts = ('--pkgname', '--ctan');

my @pkgs = generate_pkg_array(@ARGV) or exit 1;

my @ctanbib_cmd_line = ($ctanbib_cmd, @ctanbib_opts, @pkgs);

system(@ctanbib_cmd_line) == 0 or exit 1;
exit 0;

__END__
