use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'XEditable',
    AUTHOR        => 'Some Person <person@example.com>',
    VERSION_FROM  => 'app.psgi',
    PREREQ_PM     => {
        'Amon2'                           => '4.03',
        'Amon2::Lite'                     => '0.10',
        'Text::Xslate'                    => '1.5006',
        'Plack::Session'                  => '0.14',
        'Teng::Schema::Loader'            => '0',
        'DBI'                             => '0',
    },
    MIN_PERL_VERSION => '5.008001',
    (-d 'xt' and $ENV{AUTOMATED_TESTING} || $ENV{RELEASE_TESTING}) ? (
        test => {
            TESTS => 't/*.t xt/*.t',
        },
    ) : (),
);
