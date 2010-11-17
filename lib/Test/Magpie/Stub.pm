package Test::Magpie::Stub;
BEGIN {
  $Test::Magpie::Stub::VERSION = '0.01_01';
}
use Moose;

use List::AllUtils qw( all pairwise );
use MooseX::Types::Moose qw( ArrayRef );
use Scalar::Util qw( blessed );

with 'Test::Magpie::Role::MethodCall';

has 'executions' => (
    isa => ArrayRef,
    traits => [ 'Array' ],
    default => sub { [] },
    handles => {
        _store_execution => 'push',
        _next_execution => 'shift'
    }
);

sub execute {
    my $self = shift;
    return $self->_next_execution->();
}

sub then_return {
    my $self = shift;
    my $ret = shift;
    $self->_store_execution(sub {
        return $ret;
    });
    return $self;
}

sub then_die {
    my $self = shift;
    my $exception = shift;
    $self->_store_execution(sub {
        if (blessed($exception) && $exception->can('throw')) {
            $exception->throw;
        }
        else {
            die $exception;
        }
    });
    return $self;
}

1;

__END__
=pod

=encoding utf-8

=head1 NAME

Test::Magpie::Stub

=head1 AUTHOR

  Oliver Charles

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Oliver Charles <oliver.g.charles@googlemail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

