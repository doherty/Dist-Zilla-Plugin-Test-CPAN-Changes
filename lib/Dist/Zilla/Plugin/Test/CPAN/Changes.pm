package Dist::Zilla::Plugin::Test::CPAN::Changes;
use strict;
use warnings;
# ABSTRACT: release tests for your changelog
# VERSION

use Moose;
extends 'Dist::Zilla::Plugin::InlineFiles';
with    'Dist::Zilla::Role::FileMunger';
with    'Dist::Zilla::Role::PrereqSource';

=head1 SYNOPSIS

In C<dist.ini>:

    [Test::CPAN::Changes]

=for test_synopsis
1;
__END__

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
    predicate => 'has_changelog',
);

=for Pod::Coverage munge_file register_prereqs

=cut

sub munge_file {
    my $self = shift;
    my $file = shift;
    return unless $file->name eq 'xt/release/cpan-changes.t';

    if ($self->has_changelog) {
        my $content = $file->content;
        my $changelog = $self->changelog;
        $content =~ s{\Qchanges_ok();\E}{changes_file_ok('$changelog');};
        $file->content($content);
    }
    return;
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
#!perl

use Test::More;
use_ok('Test::CPAN::Changes');
changes_ok();
done_testing();
