# テンプレット開発者ガイド

テンプレットプラグインの開発者向けガイド。

このドキュメントでは、開発者向けにテンプレットプラグインの実装方法を説明します。

「テンプレット」は「テンプレートセット」とほとんど同じなので、このドキュメントは両者の相違点にフォーカスして説明します。テンプレートセットにあまり馴染みのない方は、先にシックスアパートのドキュメント([テンプレートセットの登録](http://www.movabletype.jp/documentation/designer/register-template-sets.html))に目を通すことをお勧めします。

## 基本

「テンプレット」と「テンプレートセット」の相違点は以下の通りです。

 * テンプレートセットはtemplate_setsのインスタンスを定義するのに対して、テンプレットはtempletsのインスタンスを定義する。
 * テンプレートセットはインデックステンプレート、アーカイブテンプレート、システムテンプレートなどすべてのテンプレートを定義する必要があるのに対して、テンプレットはテンプレットに含みたいテンプレートのみを定義すればよい。

以下はテンプレットを登録するコードの抜粋です。より完全なコードはあとで示します。

    sub init_registry {
        my $plugin = shift;
        $plugin->registry({
            templets => {
                my_templet => {
                    label => "My Templet",
                    base_path => 'templates',
                    order => 100,
                    templates => {
                         # templates specified here
                    },
                },
            },
        });
    };

[テンプレートセットの登録](http://www.movabletype.jp/documentation/designer/register-template-sets.html)の例と比較すると、テンプレットがtemplate_setsのインスタンスではなく、templetsのインスタンスを定義していることが容易に分かるでしょう。

上のコードはYAMLを使って以下のように書き直すこともできます。

    templets:
       my_templet:
         label: My Templet
         base_path: templates
         order: 100
         templates:
           # templates specified here

## サンプル

TempletsプラグインはMyTempletという名前のサンプルテンプレットを同梱しています。以下にMyTempletのコードを示します。

    sub init_registry {
        my $plugin = shift;
        $plugin->registry({
            templets => {
                my_templet => {
                    label => "My Templet",
                    base_path => 'templates',
                    order => 100,
                    templates => {
                        index => {
                            'homepage' => {
                                label => 'My Homepage',
                                outfile => 'index.php',
                                rebuild_me => '1',
                            },
                        },
                        individual => {
                            'entry' => {
                                label => 'Blog Entry',
                                mappings => {
                                    entry_archive => {
                                        archive_type => 'Individual',
                                        preferred => '0',
                                    },
                                },
                            },
                        },
                        archive => {
                            'another_entry' => {
                                label => 'Another Blog Entry',
                                mappings => {
                                    entry_archive => {
                                        archive_type => 'Individual',
                                        file_template => '%c/%f',
                                        preferred => '1',
                                    },
                                },
                            },
                            'entry_listing' => {
                                label => 'Blog Entry Listing',
                                mappings => {
                                    monthly => {
                                        archive_type => 'Monthly',
                                    },
                                    category => {
                                        archive_type => 'Category',
                                        file_template => '%c/index.html',
                                    },
                                },
                            },
                        },
                        system => {
                            'search_results' => {
                                label => 'Search Results',
                                description_label => '',
                            },
                        },
                        module => {
                            'foo' => {
                                label => 'Foo Module',
                            },
                        },
                    },
                },
            },
        });
    }

このPerlコードもまたYAMLを使って以下のように書き直すことができます。

    templets:
      my_templet:
        label: My Templet
        base_path: templates
        order: 100
        templates:
          index:
            homepage:
              label: My Homepage
              outfile: index.php
              rebuild_me: 1
          individual:
            entry:
              label: Blog Entry
              mappings:
                entry_archive:
                  archive_type: Individual
                  preferred: 0
          archive:
            another_entry:
              label: Another Blog Entry
              mappings:
                entry_archive:
                  archive_type: Individual
                  file_template: %c/%f
                  preferred: 1
            entry_listing:
              label: Blog Entry Listing
              mappings:
                monthly:
                  archive_type: Monthly
                category:
                  archive_type: Category
                  file_template: %c/index.html
          system:
            search_results:
              label: Search Results
          module:
            foo:
              label: Foo Module

[iPhoneTemplet](https://github.com/ogawa/mt-plugin-iPhoneTemplet)は、実用的なテンプレットのサンプルコードです。このテンプレットを使うと、簡単にiPhoneフレンドリーなページを生成するようにブログを設定できます。

## See Also

## License

Copyright (c) 2008 Hirotaka Ogawa <hirotaka.ogawa at gmail.com>.
All rights reserved.
