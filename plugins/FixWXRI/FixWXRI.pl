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
    author_name => 'masiuchi',
    author_link => 'https://github.com/masiuchi/',
    plugin_link => 'https://github.com/masiuchi/mt-plugin-fix-wxri/',
    description => 'Fix an error of WXRImporter.',
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
