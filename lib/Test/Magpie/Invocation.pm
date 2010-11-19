package Test::Magpie::Invocation;
BEGIN {
  $Test::Magpie::Invocation::VERSION = '0.03';
}
# ABSTRACT: Represents an invocation of a method
use Moose;

with 'Test::Magpie::Role::MethodCall';

1;



__END__
=pod

=encoding utf-8

=head1 NAME

Test::Magpie::Invocation - Represents an invocation of a method

=head1 INTERNAL

This class is only meant for internal usage and has no public API

=head1 AUTHOR

Oliver Charles

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Oliver Charles <oliver.g.charles@googlemail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

