package JavaScript::MochiKit;

use strict;
use vars qw[ $VERSION ];
use base qw[ JavaScript::MochiKit::Accessor ];

$VERSION = '0.02';

my %JavaScriptDefinitions = ();

=head1 NAME

JavaScript::MochiKit - JavaScript::MochiKit makes Perl suck less

=head1 SYNOPSIS

    #!/usr/bin/perl

    use strict;
    use warnings;
    use JavaScript::MochiKit;

    JavaScript::MochiKit::require('Base', 'Async');

    print JavaScript::MochiKit::javascript_definitions;


=head1 DESCRIPTION


=head1 FUNCTIONS

=head2 JavaScript::MochiKit::require( @classes )

Loades the given MochiKit classes and also their required Javascript code.
Returns 1 on success, dies on error.

=cut

sub require {
    my (@classes) = @_;

    my $this = __PACKAGE__;
    die("$this\::require() takes at least one argument") if @classes < 1;

    foreach my $class (@classes) {
        die("$this\::require() can only be run as a class method")
          if ref $class;

        next if defined $JavaScriptDefinitions{ uc $class };

        my $core_namespace = "$this\::$class";
        my $pack_namespace = "$this\::JS::$class";

        foreach ( $core_namespace, $pack_namespace ) {
            eval "CORE::require $_";
            die $@ if $@;
        }

        my $data;
        {
            no strict 'refs';
            $data = *{"${pack_namespace}::DATA"};
        }
        {
            local $/;
            $JavaScriptDefinitions{ uc $class } = <$data>;
        }
    }

    return 1;
}

=head2 JavaScript::MochiKit::require_all( )

Loades all MochiKit classes and also their required Javascript code.
Returns 1 on success, dies on error.

=cut

sub require_all {

    my @classes = qw[
      Core Base Iter Logging
      DateTime Format Async DOM
      LoggingPane Color Visual
    ];

    &require(@classes);
}

=head2 JavaScript::MochiKit::javascript_definitions( @classes )

Returns the Javascript code as one big string for all wanted
classes. Calls JavaScript::MochiKit::require(  ) for all classes that are not loaded yet.

Returns the Javascript code for all loaded classes if @classes is empty. Returns an empty
string if no class is loaded.

=cut

sub javascript_definitions {
    my (@classes) = @_;
    @classes = keys %JavaScriptDefinitions if @classes < 1;

    my $retval = '';
    foreach my $class (@classes) {
        &require($class)
          unless defined $JavaScriptDefinitions{ uc $class };

        $retval .= $JavaScriptDefinitions{ uc $class };
        $retval .= "\n";
    }

    return $retval;
}

=head1 METHODS


=head1 SEE ALSO

L<Catalyst>

L<http://www.catalystframework.org>, L<http://www.mochikit.org>

=head1 AUTHOR

Sascha Kiefer, C<esskar@cpan.org>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut

1;
