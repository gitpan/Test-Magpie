package Test::Magpie::Mock;
{
  $Test::Magpie::Mock::VERSION = '0.07';
}
# ABSTRACT: A mock object
use Moose -metaclass => 'Test::Magpie::Meta::Class';
use namespace::autoclean;

use aliased 'Test::Magpie::Invocation';
use aliased 'Test::Magpie::Stub';

use Test::Magpie::Util qw(
    extract_method_name
    get_attribute_value
    has_caller_package
);

use MooseX::Types::Moose qw( ArrayRef Int Str );
use MooseX::Types::Structured qw( Map );
use UNIVERSAL::ref;

has 'class' => (
    isa => Str,
    reader => 'ref',
    default => __PACKAGE__,
);

has 'invocations' => (
    isa => ArrayRef[Invocation],
    is => 'bare',
    default => sub { [] }
);

has 'stubs' => (
    isa => Map[ Str, ArrayRef[Stub] ],
    is => 'bare',
    default => sub { {} }
);

our $AUTOLOAD;
sub AUTOLOAD {
    my $self = shift;
    my $method_name = extract_method_name($AUTOLOAD);

    # record the method invocation for verification
    my $invocation  = Invocation->new(
        method_name => $method_name,
        arguments   => \@_,
    );

    my $invocations = get_attribute_value($self, 'invocations');
    push @$invocations, $invocation;

    # find a stub to return a response
    if (
        my $stubs = get_attribute_value($self, 'stubs')->{ $method_name }
    ) {
        for my $stub (@$stubs) {
            return $stub->execute if (
                $stub->satisfied_by($invocation) &&
                $stub->_has_executions
            );
        }
        return;
    }
}

sub does {
    return if has_caller_package('UNIVERSAL::ref');
    return 1;
}

sub isa {
    my ($self, $package) = @_;
    return if (
        has_caller_package('UNIVERSAL::ref') ||
        $package =~ /^Class::MOP::*/
    );
    return 1;
}

__PACKAGE__->meta->make_immutable;
1;

__END__

=pod

=encoding utf-8

=head1 NAME

Test::Magpie::Mock - A mock object

=head1 DESCRIPTION

Mock objects are the objects you pass around as if they were real objects. They
do not have a defined API; any method call is valid. A mock on its own is in
record mode - method calls and arguments will be saved. You can switch
temporarily to stub and verification mode with C<when> and C<verify> in
L<Test::Magpie>, respectively.

=head1 ATTRIBUTES

=head2 class

This attribute is the name of the class that the object is pretending to be
blessed into. This is only needed if you call C<ref()> on the object and want
it to return a particular type.

=head2 stubs

This attribute is internal, and not publically accessible.

Returns a map of method name to stub array references. Stubs are matched against
invocation arguments to determine which stub to dispatch to.

=head2 invocations

This attribute is internal, and not publically accessible.

Returns an array reference of all method invocations on this mock.

=head1 METHODS

=head2 isa $class

Forced to return true for any package

=head2 does $role

Forced to return true for any role

=head2 ref

Returns the value of the object's C<class> attribute. This also works if you
call C<ref()> as a function instead of a method.

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
