package Test::Magpie::Types;
{
  $Test::Magpie::Types::VERSION = '0.10';
}
# ABSTRACT: Type constraints used internally by Magpie

use MooseX::Types -declare => [qw(
    Mock
    NumRange
)];

use MooseX::Types::Moose qw( Num );
use MooseX::Types::Structured qw( Tuple );

subtype NumRange, as Tuple[Num, Num], where { $_->[0] < $_->[1] };

class_type Mock, { class => 'Test::Magpie::Mock' };

1;
