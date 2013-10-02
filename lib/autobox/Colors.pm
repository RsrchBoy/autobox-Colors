package autobox::Colors;

# ABSTRACT: Simple string coloring via autobox

use strict;
use warnings;

use parent 'autobox';

sub import {
    my $class = shift @_;

    $class->SUPER::import(
        STRING => 'autobox::Colors::STRING',
        @_,
    );
}

my %effects = (
                'bold'           => 1,
                'dark'           => 2,
                'faint'          => 2,
                'underline'      => 4,
                'underscore'     => 4,
                'blink'          => 5,
                'reverse'        => 7,
                'concealed'      => 8,
              );

my %colors = (
                'black'          => 30,
                'red'            => 31,
                'green'          => 32,
                'yellow'         => 33,
                'blue'           => 34,
                'magenta'        => 35,
                'cyan'           => 36,
                'white'          => 37,

                'bright_black'   => 90,
                'bright_red'     => 91,
                'bright_green'   => 92,
                'bright_yellow'  => 93,
                'bright_blue'    => 94,
                'bright_magenta' => 95,
                'bright_cyan'    => 96,
                'bright_white'   => 97,
             );

my %grounds = (
                'on_black'          => 40,
                'on_red'            => 41,
                'on_green'          => 42,
                'on_yellow'         => 43,
                'on_blue'           => 44,
                'on_magenta'        => 45,
                'on_cyan'           => 46,
                'on_white'          => 47,

                'on_bright_black'   => 100,
                'on_bright_red'     => 101,
                'on_bright_green'   => 102,
                'on_bright_yellow'  => 103,
                'on_bright_blue'    => 104,
                'on_bright_magenta' => 105,
                'on_bright_cyan'    => 106,
                'on_bright_white'   => 107,
              );

my %all = (%effects, %colors, %grounds);
my @colors_keys = keys %colors;
my $colors_num = scalar @colors_keys;

{
    package autobox::Colors::STRING;

    use strict;
    use warnings;

    while ( my ($color, $code) = each %all ) {
        no strict 'refs';
        *{__PACKAGE__ . '::' . $color} = sub { "\e[${code}m$_[0]\e[0m" };
    }

    sub decolorize { local $_ = $_[0]; s/\e\[\d+m//g; $_ }

    sub rainbow {
        my @chars = split //, shift;
        my @colored;

        for my $char (@chars) {
            my $code = $colors{ $colors_keys[ int rand($colors_num) ] };
            # other than spaces
            $code = 0 if $char =~ /\s/;
            push(@colored, "\e[${code}m$char\e[0m");
        }
        return join '', @colored;
    }
}

!!42;

__END__

=for :stopwords zentooo

=head1 SYNOPSIS

    use autobox::Colors;
    use feature qw/say/;

    say "I"->green;
    say "love"->magenta->bold->underscore;
    say "you"->white->on_blue;

=head1 DESCRIPTION

Just call your strings what color you'd like them to be.

=head1 ORIGINAL AUTHOR

This work is pretty much a direct adaptation of L<Term::ANSIColors::Simple>.

zentooo E<lt>zentoooo@gmail.comE<gt>

=head1 SEE ALSO

Term::ANSIColors::Simple

=cut
