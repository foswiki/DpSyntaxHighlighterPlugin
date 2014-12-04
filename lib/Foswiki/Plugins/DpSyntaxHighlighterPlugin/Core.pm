# Plugin for Foswiki - The Free and Open Source Wiki, http://foswiki.org/
#
# Copyright (C) 2007 - 2010 Andrew Jones, http://andrew-jones.com
# Copyright (C) 2010 - 2014 Foswiki Contributors. Foswiki Contributors
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version. For
# more details read LICENSE in the root of this distribution.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#
# For licensing info read LICENSE file in the Foswiki root.

package Foswiki::Plugins::DpSyntaxHighlighterPlugin::Core;

use strict;
use warnings;

use Foswiki::Func();
use constant PLUGINNAME => 'DPSYNTAXHIGHLIGHTERPLUGIN';

sub new {
  my $class = shift;

  my $this = bless({
      rootDir => Foswiki::Func::getPubUrlPath() . '/' . $Foswiki::cfg{SystemWebName} . '/' . 'DpSyntaxHighlighterPlugin',
      themes => {
        'default' => 'Default',
        'django' => 'Django',
        'eclipse' => 'Eclipse',
        'emacs' => 'Emacs',
        'fadetogray' => 'FadeToGrey',
        'mdultra' => 'MDUltra',
        'midnight' => 'Midnight',
        'rdark' => 'RDark',
      },
      @_
    },
    $class
  );

  return $this->init;
}

sub init {
  my $this = shift;

  $this->{_doneCss} = 0;
  $this->{_doneJs} = 0;

  return $this;
}

sub handleTag {
  my ($this, $params, $code) = @_;

  my $el = $params->{el} || 'verbatim';
  my $lang = $params->{lang} || $params->{_DEFAULT};

  return $this->inlineError("ERROR: no language specified") unless $lang;

  # collect html5 data attrs
  my @htmlData = ();

  push @htmlData, "data-brush='$lang'";

  my $defaultToolbar = "off";
  $defaultToolbar = "on" if Foswiki::Func::isTrue($params->{collapse});

  foreach my $prop (qw(auto_links collapse gutter html_script light pad_line_numbers quick_code smart_tabs toolbar unindent)) {

    my $name = $prop;
    $name =~ s/_//g;

    my $val = $params->{$name};
    if ($name =~ /^(.*)s$/ && !defined($val)) {
      $val = $params->{$1};
    }
    $val = $defaultToolbar if !defined ($val) && $name eq 'toolbar'; 
    
    if (defined $val) {
      push @htmlData, "data-$prop='" . (Foswiki::Func::isTrue($val)?"true":"false") . "'";
    }
  }
  push @htmlData, " data-class_name='$params->{classname}'" if defined $params->{classname};
  push @htmlData, " data-title='$params->{title}'" if defined $params->{title};
  push @htmlData, " data-first_line='$params->{firstline}'" if defined $params->{firstline};
  push @htmlData, " data-tab_size='$params->{tabsize}'" if defined $params->{tabsize};
  push @htmlData, " data-highlight='[$params->{highlight}]'" if defined $params->{highlight};

  if ($el eq 'textarea') {
    # used to give sensible size if javascript not available
    push @htmlData, "data-cols='$params->{cols}'" if defined $params->{cols};
    push @htmlData, "data-rows='$params->{rows}'" if defined $params->{rows};
  }

  $this->addCss();
  $this->addJs();

  return "<$el class='syntaxHighlight' ".join(" ", @htmlData).">$code</$el>";
}

sub inlineError {
  my ($this, $msg) = @_;

  return "<div class='foswikiAlert'>ERROR: $msg</div>";
}

sub parseTheme {
  my ($this, $theme) = @_;

  foreach my $key (keys %{$this->{themes}}) {
    return $this->{themes}{$key} if $theme =~ /^($key)$/i;
  }
}

sub addCss {
  my $this = shift;

  return if $this->{_doneCss};
  $this->{_doneCss} = 1;

  my $theme = $this->parseTheme(Foswiki::Func::getPreferencesValue(PLUGINNAME . "_THEME") || 'Default') || 'Default';

  Foswiki::Func::addToZone("head", PLUGINNAME, <<HERE);
<link rel='stylesheet' href='$this->{rootDir}/styles/shCore.css' media='all' />
<link rel='stylesheet' href='$this->{rootDir}/styles/shTheme$theme.css' media='all' />
HERE

}

sub addJs {
  my $this = shift;

  return if $this->{_doneJs};
  $this->{_doneJs} = 1;

  my $code = <<HERE;
<script type='text/javascript' src='$this->{rootDir}/scripts/shCore.min.js'></script>
<script type='text/javascript' src='%PUBURLPATH%/%SYSTEMWEB%/DpSyntaxHighlighterPlugin/shInit.js'></script>
HERE

  Foswiki::Func::addToZone("script", PLUGINNAME, $code, 'JQUERYPLUGIN::FOSWIKI');
}

1;
