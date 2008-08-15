# Templets
#
# $Id
#
# This software is provided as-is. You may use it for commercial or
# personal use. If you distribute it, please keep this notice intact.
#
# Copyright (c) 2008 Hirotaka Ogawa

package MT::Plugin::Templets;
use strict;
use base qw( MT::Plugin );

use MT;

our $VERSION = '0.01';

my $plugin = __PACKAGE__->new(
    {
        id   => 'templets',
        name => 'Templets',
        description =>
q(<MT_TRANS phrase="Templets plugin provides a framework for making Template Sets pluggable.">),
        doc_link    => 'http://code.as-is.net/public/wiki/Templets',
        author_name => 'Hirotaka Ogawa',
        author_link => 'http://as-is.net/blog/',
        version     => $VERSION,
        l10n_class  => 'Templets::L10N',
    }
);
MT->add_plugin($plugin);

sub instance { $plugin }

sub init_registry {
    my $plugin = shift;
    $plugin->registry(
        {
            applications => {
                cms => {
                    methods => {
                        'dialog_append_templet' =>
                          'Templets::CMS::dialog_append_templet',
                        'finish_append_templet' =>
                          'Templets::CMS::finish_append_templet',
                    },
                    page_actions => {
                        list_templates => {
                            create_templet => {
                                label     => 'Append a templet',
                                dialog    => 'dialog_append_templet',
                                condition => sub { MT->app->blog },
                                order     => 1000,
                            },
                        },
                    },
                }
            },
        }
    );
}

1;
