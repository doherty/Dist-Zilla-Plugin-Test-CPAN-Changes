
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  "build_requires" => {
    "Module::Build" => "0.3601"
  },
  "configure_requires" => {
    "Module::Build" => "0.3601"
  },
  "dist_abstract" => "release tests for your changelog",
  "dist_author" => [
    "Mike Doherty <doherty\@cpan.org>"
  ],
  "dist_name" => "Dist-Zilla-Plugin-Test-CPAN-Changes",
  "dist_version" => "0.007",
  "license" => "perl",
  "module_name" => "Dist::Zilla::Plugin::Test::CPAN::Changes",
  "recommends" => {},
  "recursive_test_files" => 1,
  "requires" => {
    "Dist::Zilla" => 4,
    "Dist::Zilla::Plugin::InlineFiles" => 0,
    "Dist::Zilla::Role::FileMunger" => 0,
    "Dist::Zilla::Role::PrereqSource" => 0,
    "Moose" => 0,
    "Test::CPAN::Changes" => "0.19",
    "perl" => "5.006",
    "strict" => 0,
    "warnings" => 0
  },
  "script_files" => [],
  "test_requires" => {
    "File::Find" => 0,
    "File::Path" => 0,
    "File::Temp" => 0,
    "Moose::Autobox" => 0,
    "Test::CPAN::Changes" => 0,
    "Test::DZil" => 0,
    "Test::More" => "0.94",
    "autodie" => 0
  }
);


unless ( eval { Module::Build->VERSION(0.4004) } ) {
  my $tr = delete $module_build_args{test_requires};
  my $br = $module_build_args{build_requires};
  for my $mod ( keys %$tr ) {
    if ( exists $br->{$mod} ) {
      $br->{$mod} = $tr->{$mod} if $tr->{$mod} > $br->{$mod};
    }
    else {
      $br->{$mod} = $tr->{$mod};
    }
  }
}

my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
