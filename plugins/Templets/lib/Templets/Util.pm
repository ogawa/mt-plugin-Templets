# $Id

package Templets::Util;
use strict;

# The following part is based on MT::DefaultTemplates->templates()
sub templet_templates {
    my $pkg = shift;
    my ($set) = @_;
    require File::Spec;

    # A set of default templates as returned by MT::Component->registry
    # yields an array of hashes.

    my @tmpl_path = $set ? ("templets", $set) : ("default_templates");
    my $all_tmpls = MT::Component->registry(@tmpl_path) || [];
    my $weblog_templates_path = MT->config('WeblogTemplatesPath');

    my (%tmpls, %global_tmpls);
    foreach my $def_tmpl (@$all_tmpls) {
        # copy structure, then run filter

        my $tmpl_hash;
        if ($def_tmpl->{templates} && ($def_tmpl->{templates} eq '*')) {
            $tmpl_hash = MT->registry("default_templates");
        }
        else {
            $tmpl_hash = $set ? $def_tmpl->{templates} : $def_tmpl;
        }
        my $plugin = $tmpl_hash->{plugin};

        foreach my $tmpl_set (keys %$tmpl_hash) {
            next unless ref($tmpl_hash->{$tmpl_set}) eq 'HASH';
            foreach my $tmpl_id (keys %{ $tmpl_hash->{$tmpl_set} }) {
                next if $tmpl_id eq 'plugin';

                my $p = $tmpl_hash->{plugin} || $tmpl_hash->{$tmpl_set}{plugin};
                my $base_path = $def_tmpl->{base_path} || $tmpl_hash->{$tmpl_set}{base_path};
                if ($p && $base_path) {
                    $base_path = File::Spec->catdir($p->path, $base_path);
                }
                else {
                    $base_path = $weblog_templates_path;
                }

                my $tmpl = { %{ $tmpl_hash->{$tmpl_set}{$tmpl_id} } };
                my $type = $tmpl_set;
                if ($tmpl_set =~ m/^global:/) {
                    $type =~ s/^global://;
                    $tmpl->{global} = 1;
                }
                $tmpl->{set} = $type; # system, index, archive, etc.
                $tmpl->{order} = 0 unless exists $tmpl->{order};

                $type = 'custom' if $type eq 'module';
                $type = $tmpl_id if $type eq 'system';
                my $name = $tmpl->{label};
                $name = $name->() if ref($name) eq 'CODE';
                $tmpl->{name} = $name;
                $tmpl->{type} = $type;
                $tmpl->{key} = $tmpl_id;
                $tmpl->{identifier} = $tmpl_id;

                # load template if it hasn't been loaded already
                if (!exists $tmpl->{text}) {
                    local (*FIN, $/);
                    my $filename = $tmpl->{filename} || ($tmpl_id . '.mtml');
                    my $file = File::Spec->catfile($base_path, $filename);
                    if ((-e $file) && (-r $file)) {
                        open FIN, "<$file"; my $data = <FIN>; close FIN;
                        $tmpl->{text} = $data;
                    } else {
                        $tmpl->{text} = '';
                    }
                }

                if ( exists $tmpl->{widgets} ) {
                    my $widgets = $tmpl->{widgets};
                    my @widgets;
                    foreach my $widget ( @$widgets ) {
                        if ( $plugin ) {
                            push @widgets, $plugin->translate( $widget );
                        }
                        else {
                            push @widgets, MT->translate( $widget );
                        }
                    }
                    $tmpl->{widgets} = \@widgets if @widgets;
                }

                my $local_global_tmpls = $tmpl->{global} ? \%global_tmpls : \%tmpls;
                if (exists $local_global_tmpls->{$tmpl_id}) {
                    # allow components/plugins to override core
                    # templates
                    $local_global_tmpls->{$tmpl_id} = $tmpl if $p && ($p->id ne 'core');
                }
                else {
                    $local_global_tmpls->{$tmpl_id} = $tmpl;
                }
            }
        }
    }
    my @tmpls = (values(%tmpls), values(%global_tmpls));
    @tmpls = sort { $a->{order} <=> $b->{order} } @tmpls;
#    MT->run_callbacks('DefaultTemplateFilter' . ($set ? '.' . $set : ''), \@tmpls);
    return \@tmpls;
}

1;
