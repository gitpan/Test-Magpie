package Test::Magpie::Util;
{
  $Test::Magpie::Util::VERSION = '0.07';
}
# ABSTRACT: Utilities used by Test::Magpie
use strict;
use warnings;
use 5.010_001; # dependency for smartmatching

use aliased 'Test::Magpie::ArgumentMatcher';

use Scalar::Util qw( blessed );
use Moose::Util qw( find_meta );

use Sub::Exporter -setup => {
    exports => [qw(
        extract_method_name
        get_attribute_value
        has_caller_package
        match
    )],
};

sub extract_method_name {
    my $name = shift;
    my ($method) = $name =~ qr/:([^:]+)$/;
    return $method;
}

sub get_attribute_value {
    my ($object, $attribute) = @_;

    return find_meta($object)
        ->find_attribute_by_name($attribute)
        ->get_value($object);
}

sub has_caller_package {
    my $package= shift;

    my $level = 1;
    while (my ($caller) = caller $level++) {
        return 1 if $caller eq $package;
    }
    return;
}

sub match {
    my ($a, $b) = @_;
    return blessed($a)
        ? (ref($a) eq ref($b) && $a == $b)
        : $a ~~ $b;
}

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Test::Magpie::Util - Utilities used by Test::Magpie

=head1 FUNCTIONS

=head2 extract_method_name

    $method_name = extract_method_name($full_method_name)

Internal. From a fully qualified method name such as Foo::Bar::baz, will return
just the method name (in this example, baz).

=head2 has_caller_package

    $bool = has_caller_package($package_name)

Internal. Returns whether the given C<$package> is in the current call stack.

=head2 get_attribute_value

    $value = get_attribute_value($object, $attr_name)

Internal. Gets value of Moose attributes that have no accessors by accessing
the class' underlying meta-object.

=head2 match

Internal. Match 2 values for equality

=head1 AUTHORS

=over 4

=item *

Oliver Charles <oliver.g.charles@googlemail.com>

=item *

Steven Lee <stevenwh.lee@gmail.com>

=back

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Oliver Charles.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
