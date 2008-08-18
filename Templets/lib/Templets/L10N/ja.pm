# $Id$
package Templets::L10N::ja;

use strict;
use base qw( Templets::L10N );

our %Lexicon = (
    '_TEMPLETS_DESCRIPTION' =>
qq{Templetsプラグインは、テンプレートセットをpluggableにするためのフレームワークを提供します。},
    'Append a templet' => 'テンプレットを追加',
    'Select a templet' => 'テンプレットの選択',
    'Append'           => '追加',
    'Overwrite existing templates' =>
      '既存のテンプレートを上書きする',
    'Make backups of existing templates first' =>
      '既存のテンプレートのバックアップを作成する',
);

1;
