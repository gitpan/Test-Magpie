
use strict;
use warnings;



use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "Spy on objects to achieve test doubles (mock testing)\r",
  "AUTHOR" => "Oliver Charles",
  "BUILD_REQUIRES" => {},
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "Test-Magpie",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "NAME" => "Test::Magpie",
  "PREREQ_PM" => {
    "Devel::PartialDump" => "0.13",
    "List::AllUtils" => "0.02",
    "Moose" => "1.14",
    "MooseX::Params::Validate" => 0,
    "MooseX::Types::Moose" => "0.21",
    "MooseX::Types::Structured" => "0.21",
    "Set::Object" => "1.28",
    "Sub::Exporter" => "0.982",
    "Test::Builder" => "0.96",
    "UNIVERSAL::ref" => "0.12",
    "aliased" => "0.30",
    "namespace::autoclean" => "0.09"
  },
  "TEST_REQUIRES" => {
    "Test::Fatal" => "0.003",
    "Test::Moose" => 0,
    "Test::More" => "0.96"
  },
  "VERSION" => "0.06",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  my $tr = delete $WriteMakefileArgs{TEST_REQUIRES};
  my $br = $WriteMakefileArgs{BUILD_REQUIRES};
  for my $mod ( keys %$tr ) {
    if ( exists $br->{$mod} ) {
      $br->{$mod} = $tr->{$mod} if $tr->{$mod} > $br->{$mod};
    }
    else {
      $br->{$mod} = $tr->{$mod};
    }
  }
}

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



