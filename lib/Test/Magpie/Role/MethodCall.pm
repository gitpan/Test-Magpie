package Test::Magpie::Role::MethodCall;
BEGIN {
  $Test::Magpie::Role::MethodCall::VERSION = '0.01_01';
}
use Moose::Role;
use namespace::autoclean;

use MooseX::Types::Moose qw( ArrayRef Str );
use Devel::PartialDump;

has 'method_name' => (
    isa => Str,
    is => 'ro',
    required => 1
);

has 'arguments' => (
    traits => [ 'Array' ],
    isa => ArrayRef,
    default => sub { [] },
    handles => {
        arguments => 'elements'
    }
);

sub as_string {
    my $self = shift;
    return $self->method_name .
        '(' . Devel::PartialDump->new->dump($self->arguments) . ')';
}

sub satisfied_by {
    my ($self, $invocation) = @_;
    return
        $invocation->method_name eq $self->method_name &&
        @{[ $invocation->arguments ]} ~~ @{[ $self->arguments ]};
}

1;

__END__
=pod

=encoding utf-8

=head1 NAME

Test::Magpie::Role::MethodCall

=head1 AUTHOR

  Oliver Charles

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Oliver Charles <oliver.g.charles@googlemail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

