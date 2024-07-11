#!/usr/bin/env perl
# scripts/build.pl -*-perl-*-
#
# Perl script to ease building the latex sty file and documentation
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

use Getopt::Long;
use Path::Tiny;
use Pod::Usage;

sub generate_package($filename)
{
  system("latex $filename") == 0
    or die "Generation of .sty file failed with exit code: $?";
}

sub generate_docs($filename, @latexmk_options)
{
  system("latexmk", '-jobname=%A-doc', @latexmk_options, "$filename") == 0
    or die "Generation of documentation failed with exit code: $?";
}


# script starts here

my $help= '';
my @latexmk_opts = ();
my $basename = "moremath";

my $error = 0;

# define the options
GetOptions('latexmk-options|o=s' => \@latexmk_opts,
           'help|h' => \$help)
  or pod2usage(2);
pod2usage(1) if $help;

# join and split the latexmk options
@latexmk_opts = split(/;/, join(';', @latexmk_opts));

# check if a basename has been given on the command line
$basename = $ARGV[0] if $ARGV;

my $ins_filename = $basename . ".ins";
my $dtx_filename = $basename . ".dtx";

if (path($ins_filename)->is_file) {
  eval {
    generate_package($ins_filename);
  };
  # check for errors
  if ($@) {
  warn $@;
  $error += 1;
  }
} else {
  warn "File $ins_filename does not exist.";
  $error += 1;
}

if (path($dtx_filename)->is_file) {
  eval {
    generate_docs($dtx_filename, @latexmk_opts);
  };
  if ($@) {
    warn $@;
    $error += 1;
  }
} else {
  warn "File $dtx_filename does not exist.";
  $error += 1;
}

exit(1) if $error;
exit(0);



__END__


=head1 NAME

build.pl - Script for building a latex package

=head1 SYNOPSIS

S<B<./build.pl> [B<-o> I<latexmk_opts>...] [I<file_basename>]>

S<B<./build.pl> B<-h>|B<--help>>

=head1 DESCRIPTION

This script builds a latex package and its accompanying documentation.
It produces the package code file using a C<.ins> file.
By default it tries to built F<moremath.sty> from F<moremath.dtx>.
The produced documentation file will be named I<file_basename>-doc.pdf.

=head1 OPTIONS

=over

=item B<-o>, B<--latexmk-options> I<latexmk_opts>

Passes the given options I<latexmk_opts> to L<latexmk(1)>.
The options may be separated using semicolons "B<;>".
This option may be given multiple times.

=item B<-h>, B<--help>

Produce a help message and exit.

=back

=head1 EXIT STATUS

=over

=item B<0>

On normal execution and termination.

=item B<1>

On abnormal termination.

=item B<2>

On invalid command line usage.

=back

=head1 COPYRIGHT

Copyright (c) 2024 Marcel Ilg

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

=head1 SEE ALSO

L<latexmk(1)>, L<latex(1)>

=cut
