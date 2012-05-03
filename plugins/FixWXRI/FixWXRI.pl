package MT::Plugin::FixWXRI;
use strict;
use warnings;
use base 'MT::Plugin';

our $VER  = '0.01';
our $NAME = ( split /::/, __PACKAGE__ )[-1];

my $plugin = __PACKAGE__->new({
    name        => $NAME,
    id          => lc $NAME,
    key         => lc $NAME,
    version     => $VER,
    author_name => 'masiuchi',
    author_link => 'https://github.com/masiuchi/',
    plugin_link => 'https://github.com/masiuchi/mt-plugin-fix-wxri/',
    description => 'Avoid an error of WXR Importer 1.11.',
    init_app    => \&_init_app,
});
MT->add_plugin( $plugin );

sub _init_app {
    my $wxri = MT->component( 'WXRImporter' );

    if ( $wxri ) {
        require WXRImporter::WXRHandler;
        my $orig = \&WXRImporter::WXRHandler::_create_asset;

        no warnings 'redefine';
        *WXRImporter::WXRHandler::_create_asset = sub {
            my ( $self, $hashes ) = @_;

            if ( grep { $_->{wp_postmeta}{_wp_attached_file} } @$hashes ) {
                $orig->( $self, $hashes );
            }
        };
    }
}

1;
__END__
