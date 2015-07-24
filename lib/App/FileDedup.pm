package App::FileDedup;

use strict;
use warnings;

use File::Dedup;
use MooseX::App::Simple;
use MooseX::Types::Moose qw/Bool Str/;

option 'nonrecursive' => (
   is            => 'ro',
   isa           => Bool,
   default       => 0,
   cmd_aliases   => [qw(f)],
   cmd_flag      => 'non-recursive',
   documentation => 'Only do a top-level search',
);

option 'dontask' => (
   is            => 'ro',
   isa           => Bool,
   default       => 0,
   cmd_aliases   => [qw(n)],
   cmd_flag      => 'dont-ask',
   documentation => 'Purge files without an interactive prompt; off by default',
);

option 'group' => (
   is            => 'ro',
   isa           => Bool,
   default       => 0,
   cmd_aliases   => [qw(g)],
   documentation => 'Group duplicate files into subfolders instead of deleting',
);

parameter 'directory' => (
   is            => 'ro',
   isa           => Str,
   required      => 1,
   documentation => 'Directory to begin searching for duplicates',
);

sub run {
   my ($self) = @_;

   my $deduper = File::Dedup->new(
      directory => $self->directory,
      ask       => !$self->dontask,
      recursive => !$self->nonrecursive,
      group     => $self->group,
   );
   $deduper->dedup;
}

1;
