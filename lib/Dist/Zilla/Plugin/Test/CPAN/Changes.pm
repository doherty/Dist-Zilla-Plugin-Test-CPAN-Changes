package Dist::Zilla::Plugin::Test::CPAN::Changes;
use strict;
use warnings;
# ABSTRACT: release tests for your changelog
# VERSION

use Moose;
use Data::Section -setup;
with
    'Dist::Zilla::Role::FileGatherer',
    'Dist::Zilla::Role::PrereqSource';

=head1 SYNOPSIS

In C<dist.ini>:

    [Test::CPAN::Changes]

=begin :prelude

=for test_synopsis BEGIN { die "SKIP: synopsis isn't perl code" }

=end :prelude

=head1 DESCRIPTION

This is an extension of L<Dist::Zilla::Plugin::InlineFiles>, providing the
following file:

    xt/release/cpan-changes.t - a standard Test::CPAN::Changes test

See L<Test::CPAN::Changes> for what this test does.

=head2 Alternate changelog filenames

L<CPAN::Changes::Spec> specifies that the changelog will be called 'Changes' -
if you want to use a different filename for whatever reason, do:

    [Test::CPAN::Changes]
    changelog = CHANGES

and that file will be tested instead.

=cut

has changelog => (
    is      => 'ro',
    isa     => 'Str',
    default => 'Changes',
);

around dump_config => sub
{
    my ($orig, $self) = @_;
    my $config = $self->$orig;

    $config->{+__PACKAGE__} = {
        changelog => $self->changelog,
        blessed($self) ne __PACKAGE__
            ? ( version => (defined __PACKAGE__->VERSION ? __PACKAGE__->VERSION : 'dev') )
            : (),
    };
    return $config;
};

=for Pod::Coverage gather_files register_prereqs

=cut

sub gather_files {
    my $self = shift;

    require Dist::Zilla::File::InMemory;

    for my $file (qw( xt/release/cpan-changes.t )){
        my $content = ${$self->section_data($file)};

        my $changes_filename = $self->changelog;

        $content =~ s/CHANGESFILENAME/$changes_filename/;
        $content =~ s/PLUGIN/ref($self)/e;
        $content =~ s/VERSION/$self->VERSION || '<self>'/e;

        $self->add_file( Dist::Zilla::File::InMemory->new(
            name => $file,
            content => $content,
        ));
    }
}

# Register the release test prereq as a "develop requires"
# so it will be listed in "dzil listdeps --author"
sub register_prereqs {
  my ($self) = @_;

  $self->zilla->register_prereqs(
    {
      type  => 'requires',
      phase => 'develop',
    },
    # Latest known release of Test::CPAN::Changes
    # because CPAN authors must use the latest if we want
    # this check to be relevant
    'Test::CPAN::Changes'     => '0.19',
  );
}





__PACKAGE__->meta->make_immutable;
no Moose;

__DATA__
__[ xt/release/cpan-changes.t ]__
use strict;
use warnings;

# this test was generated with PLUGIN VERSION

use Test::More 0.96 tests => 1;
use Test::CPAN::Changes;
subtest 'changes_ok' => sub {
    changes_file_ok('CHANGESFILENAME');
};
