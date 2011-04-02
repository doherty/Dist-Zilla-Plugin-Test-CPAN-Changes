package Dist::Zilla::Plugin::ChangesTests;
use strict;
use warnings;
# ABSTRACT: release tests for your changelog
# VERSION

use Moose;
extends 'Dist::Zilla::Plugin::InlineFiles';
with    'Dist::Zilla::Role::FileMunger';

=head1 SYNOPSIS

In C<dist.ini>:

    [ChangesTests]

=head1 DESCRIPTION

This is an extension of L<Dist::Zilla::Plugin::InlineFiles>, providing the
following file:

    xt/release/cpan-changes.t - a standard Test::CPAN::Changes test

See L<Test::CPAN::Changes> for what this test does.

You should use this plugin instead of L<Dist::Zilla::Plugin::CPANChangesTests>
because this one lets you cheat on the filename.

=head2 Alternate changelog filenames

L<CPAN::Changes::Spec> specifies that the changelog will be called 'Changes' -
if you want to use a different filename for whatever reason, do:

    [ChangesTests]
    changelog = CHANGES

and that file will be tested instead.

=for Pod::Coverage munge_file

=cut

has changelog => (
    is      => 'ro',
    isa     => 'Str',
    predicate => 'has_changelog',
);

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

__PACKAGE__->meta->make_immutable;
no Moose;

__DATA__
__[ xt/release/cpan-changes.t ]__
#!perl

use Test::More;
eval 'use Test::CPAN::Changes';
plan skip_all => 'Test::CPAN::Changes required for this test' if $@;
changes_ok();
done_testing();
