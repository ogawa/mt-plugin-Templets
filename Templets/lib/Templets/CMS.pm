# $Id

package Templets::CMS;
use strict;
use base qw( MT::App );

sub dialog_append_templet {
    my $app = shift;
    $app->validate_magic or return;

    # check permissions
    my $perms = $app->permissions;
    return $app->errtrans("Permission denied.")
      unless $app->user->is_superuser()
          || $app->user->can_edit_templates()
          || (
              $perms
              && (   $perms->can_edit_templates()
                  || $perms->can_administer_blog() )
          );

    my $param = {
        screen_id   => 'append-templet-dialog',
        return_args => $app->param('return_args'),
    };

    if ( my $blog = $app->blog ) {
        $param->{blog_id} = $blog->id;

        my $templets = $app->registry('templets');
        $templets->{$_}{key} = $_ for keys %$templets;
        $templets =
          $app->filter_conditional_list( [ values %$templets ] );    # ARRAYREF

        no warnings;    # some sets may not define an order
        @$templets = sort { $a->{order} <=> $b->{order} } @$templets;

        $param->{templets_index} = scalar @$templets - 1;
        $param->{templets_count} = scalar @$templets;
        $param->{templets_loop}  = $templets;
    }

    my $plugin = MT::Plugin::Templets->instance;
    my $tmpl   = $plugin->load_tmpl('dialog_append_templet.tmpl');
    $app->build_page( $tmpl, $param );
}

sub finish_append_templet {
    my $app = shift;
    $app->validate_magic or return;

    # check permissions
    my $perms = $app->permissions;
    return $app->errtrans("Permission denied.")
      unless $app->user->is_superuser()
          || $app->user->can_edit_templates()
          || (
              $perms
              && (   $perms->can_edit_templates()
                  || $perms->can_administer_blog() )
          );

    my $blog       = $app->blog;
    my $templet_id = $app->param('templet_id');
    require Templets::Util;
    my $tmpl_list = Templets::Util->templet_templates($templet_id);
    return $app->error(
        $app->translate( "No [_1] templets were found.", $templet_id ) )
      if !$tmpl_list || ( ref($tmpl_list) ne 'ARRAY' ) || ( !@$tmpl_list );

    # The following part is based on MT::Blog->create_default_templates()
    require MT::Template;
    my @arch_tmpl;
    for my $val (@$tmpl_list) {
        next if $val->{global};

        # check if tmpl exists
        my $terms = {
            blog_id => $blog->id,
            type    => $val->{type},
        };
        if ( $val->{type} =~
m/^(archive|individual|page|category|index|custom|widget|widgetset)$/
          )
        {
            $terms->{name} = $val->{name};
        }
        else {
            $terms->{identifier} = $val->{identifier};
        }
        next if MT::Template->exist($terms);

        my $obj = MT::Template->new;
        my $p = $val->{plugin} || 'MT';
        local $val->{name} = $val->{name};
        local $val->{text} = $p->translate_templatized( $val->{text} );
        $obj->build_dynamic(0);
        foreach my $v ( keys %$val ) {
            $obj->column( $v, $val->{$v} ) if $obj->has_column($v);
        }
        $obj->blog_id( $blog->id );
        if ( my $pub_opts = $val->{publishing} ) {
            $obj->include_with_ssi(1) if $pub_opts->{include_with_ssi};
        }
        if (   ( 'widgetset' eq $val->{type} )
            && ( exists $val->{widgets} ) )
        {
            my $modulesets = delete $val->{widgets};
            $obj->modulesets(
                MT::Template->widgets_to_modulesets( $modulesets, $blog->id ) );
        }
        $obj->save
          or return $app->error(
            $app->translate("Error creating new template: ") . $obj->errstr );

        if ( $val->{mappings} ) {
            push @arch_tmpl,
              {
                template => $obj,
                mappings => $val->{mappings},
                exists( $val->{preferred} )
                ? ( preferred => $val->{preferred} )
                : ()
              };
        }
    }

    if (@arch_tmpl) {
        require MT::TemplateMap;
        for my $map_set (@arch_tmpl) {
            my $tmpl     = $map_set->{template};
            my $mappings = $map_set->{mappings};
            foreach my $map_key ( keys %$mappings ) {
                my $m  = $mappings->{$map_key};
                my $at = $m->{archive_type};

                # my $preferred = $mappings->{$map_key}{preferred};
                my $map = MT::TemplateMap->new;
                $map->archive_type($at);
                if ( exists $m->{preferred} ) {
                    $map->is_preferred( $m->{preferred} );
                }
                else {
                    $map->is_preferred(1);
                }
                $map->template_id( $tmpl->id );
                $map->file_template( $m->{file_template} )
                  if $m->{file_template};
                $map->blog_id( $tmpl->blog_id );
                $map->save;
            }
        }
    }

    $blog->custom_dynamic_templates('none');
    $blog->save;

    $app->add_return_arg( 'refreshed' => 1 );
    $app->call_return;
}

1;
