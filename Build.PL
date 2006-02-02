use strict;
use Module::Build;

my $build = Module::Build->new(
    create_makefile_pl => 'traditional',
    license            => 'perl',
    module_name        => 'JavaScript::MochiKit',
    create_readme      => 1,
    sign               => 1,
    test_files         => [ glob('t/*.t') ],
    requires           => { 'Class::Accessor::Fast' => 0, },
);

$build->create_build_script;
