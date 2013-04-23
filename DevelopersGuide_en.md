# Templet Developer's Guide

This document is to explain how to implement templet plugins for developers.

Because "templet" is almost same as "template set", this document only focuses on how is the difference between "templet" and "template set".  If you are not familiar with "template sets", I strongly recommend that you read Six Apart's document ([Registering Template Sets](http://www.movabletype.org/documentation/mt41/register-template-sets.html)) first.

## Basic

The only differences between "templet" and "template set" are:

 * While a template set defines an instance of "template_sets", a templet defines an instance of "templets".
 * While a template set must define all templates such as index templates, archive templates, and system templates etc., a templet defines templates that you want to include.

The following is an excerpt of a code sample to register a templet. A more complete example is provided below.

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

In comparison with an example of [Registering Template Sets](http://www.movabletype.org/documentation/mt41/register-template-sets.html ), you'll easily find that a templet defines an instance of "templets", instead of an instance of "template_sets".

The above example can be rewritten by using YAML:

    templets:
       my_templet:
         label: My Templet
         base_path: templates
         order: 100
         templates:
           # templates specified here

## Example

Templets plugin is shipped with an example templet named "MyTemplet".  The following is the sample code from MyTemplet.

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

The above code can also be rewritten by using YAML.

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

[iPhoneTemplet](https://github.com/ogawa/mt-plugin-iPhoneTemplet) is another example of a templet implementation; you'll be able to set up iPhone-friendly pages quite easily by using this templet.

## See Also

## License

Copyright (c) 2008 Hirotaka Ogawa <hirotaka.ogawa at gmail.com>.
All rights reserved.
