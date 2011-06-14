
use strict;
use warnings;

use 5.006;

use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  'ABSTRACT' => 'release tests for your changelog',
  'AUTHOR' => 'Mike Doherty <doherty@cpan.org>',
  'BUILD_REQUIRES' => {
    'File::Find' => '0',
    'File::Path' => '0',
    'File::Temp' => '0',
    'Moose::Autobox' => '0',
    'Test::CPAN::Changes' => '0',
    'Test::DZil' => '0',
    'Test::More' => '0.94',
    'autodie' => '0'
  },
  'CONFIGURE_REQUIRES' => {
    'ExtUtils::MakeMaker' => '6.30'
  },
  'DISTNAME' => 'Dist-Zilla-Plugin-Test-CPAN-Changes',
  'EXE_FILES' => [],
  'LICENSE' => 'perl',
  'NAME' => 'Dist::Zilla::Plugin::Test::CPAN::Changes',
  'PREREQ_PM' => {
    'Dist::Zilla' => '4',
    'Dist::Zilla::Plugin::InlineFiles' => '0',
    'Dist::Zilla::Role::FileMunger' => '0',
    'Moose' => '0'
  },
  'VERSION' => '0.005',
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



