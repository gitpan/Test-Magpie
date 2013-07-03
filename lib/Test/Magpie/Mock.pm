package Test::Magpie::Mock;
{
  $Test::Magpie::Mock::VERSION = '0.06';
}
# ABSTRACT: A mock object
use Moose -metaclass => 'Test::Magpie::Meta::Class';
use namespace::autoclean;

use aliased 'Test::Magpie::Invocation';
use aliased 'Test::Magpie::Stub';

use Test::Magpie::Util qw( extract_method_name has_caller_package );
use List::AllUtils qw( first );
use MooseX::Types::Moose qw( ArrayRef Int Object Str );
use MooseX::Types::Structured qw( Map );
use Moose::Util qw( find_meta );
use Test::Builder;
use UNIVERSAL::ref;

has 'class' => (
    isa => Str,
    is => 'ro',
    default => __PACKAGE__,
);

has 'invocations' => (
    isa => ArrayRef,
    is => 'bare',
    default => sub { [] }
);

has 'stubs' => (
    isa => Map[Str, Object],
    is => 'bare',
    default => sub { {} }
);

our $AUTOLOAD;

sub AUTOLOAD {
    my $method = $AUTOLOAD;
    my $self = shift;
    my $meta = find_meta($self);
    my $invocations = $meta->find_attribute_by_name('invocations')
        ->get_value($self);
    my $invocation = Invocation->new(
        method_name => extract_method_name($method),
        arguments => \@_
    );

    push @$invocations, $invocation;

    if(my $stubs = $meta->find_attribute_by_name('stubs')->get_value($self)->{
        $invocation->method_name
    }) {
        my $stub_meta = find_meta(Stub);
        my @possible = grep { $_->satisfied_by($invocation) } @$stubs;
        for my $stub (@possible) {
            if ($stub->_has_executions) {
                return $stub->execute;
            }
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

sub ref { $_[0]->class }

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

=head1 AUTHOR

Oliver Charles

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Oliver Charles <oliver.g.charles@googlemail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
