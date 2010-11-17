
use strict;
use warnings;



use ExtUtils::MakeMaker 6.31;



my %WriteMakefileArgs = (
  'ABSTRACT' => 'Spy on objcets to achieve test doubles (mock testing)',
  'AUTHOR' => 'Oliver Charles',
  'BUILD_REQUIRES' => {},
  'CONFIGURE_REQUIRES' => {
    'ExtUtils::MakeMaker' => '6.31'
  },
  'DISTNAME' => 'Test-Magpie',
  'EXE_FILES' => [],
  'LICENSE' => 'perl',
  'NAME' => 'Test::Magpie',
  'PREREQ_PM' => {
    'Devel::PartialDump' => '0.13',
    'List::AllUtils' => '0.02',
    'Moose' => '1.14',
    'MooseX::Types::Moose' => '0.21',
    'MooseX::Types::Structured' => '0.21',
    'Sub::Exporter' => '0.982',
    'Test::Builder' => '0.96',
    'Test::Fatal' => '0.003',
    'Test::More' => '0.96',
    'aliased' => '0.30',
    'namespace::autoclean' => '0.09'
  },
  'VERSION' => '0.01_01',
  'test' => {
    'TESTS' => 't/*.t'
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



