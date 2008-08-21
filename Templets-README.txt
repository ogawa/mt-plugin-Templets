Templets - A plugin for making Template Sets pluggable

= Overview =

Templets plugin realizes "pluggable template sets" called "templet",
and allows you to install and manange new templates very
straightforwardly and flexibly.  It makes very easy:

 * For users to customize their base template sets by plugging in
   various kinds of templets, such as iPhone/cellphone templet, widget
   template library templet, and ActionStreams templet if available.

 * For template designers to package and distribute their own
   templates.

 * For plugin developers to package and distribute sample templates
   that use newly implemented template tags, into their plugins.

Until now, installing and updating templates have been a bothersome
task with a lot of cut-and-paste.  But from now, Templets provides a
"turn-key" solution to install any templates into your blogs.

NOTE: Latest version of Templets plugin and document is available from
      [1].

= Installation =

 * Download and extract Templets-<version>.zip file.

 * Upload or copy the contents of "plugins" directory into your
   "plugins" directory.

   NOTE: "plugins/MyTemplet" is an example templet. If not required,
         you don't need to upload this.

 * After proper installation, you will find "Templets" plugin listed
   on the "System Plugin Settings" screen.

= How to use =

Currently, Templets plugin provides just one feature that is for
appending a templet to current template set.

 * Go to [Design]->[Templates] and then choose the [Append a templet]
   link from the "Action" list, which is located lower-right of the
   page.

 * Choose a templet from the drop-down box if available. If you want
   to overwrite existing templates by selected templet, check
   [Overwrite existing templates] box. And if you want to make backups
   for existing templates which may be overwritten, check [Make
   backups of existing templates first] box.

 * Then click [Append].

 * You'll move to [Design]->[Templates] screen and find templates
   which are included in the templet

= About Templet =

This plugin only includes an example templet named "MyTemplet".

If you'd like to plug and use other templets in your template set, you
have to separately download templet implementations from third-party,
or to create your own templet implementations.

For templet developers, Templet Developer's Guide[2] will explain how
they can implement templet plugins so easily.

= References =

[1] Templets
    [http://code.as-is.net/public/wiki/Templets]

[2] Templet Developer's Guide
    [http://code.as-is.net/public/wiki/TempletDevelopersGuide]

--
$Id$
