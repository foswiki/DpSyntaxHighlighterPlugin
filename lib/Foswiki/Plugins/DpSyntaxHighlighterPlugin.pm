# Plugin for Foswiki - The Free and Open Source Wiki, http://foswiki.org/
#
# Copyright (C) 2007 - 2010 Andrew Jones, http://andrew-jones.com
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

package Foswiki::Plugins::DpSyntaxHighlighterPlugin;

use strict;
use warnings;

use Foswiki::Func ();
use Foswiki::Plugins ();

our $VERSION = '3.00';
our $RELEASE = '3.00';
our $NO_PREFS_IN_TOPIC = 1;
our $SHORTDESCRIPTION = 'Client side syntax highlighting using the [[http://alexgorbatchev.com/SyntaxHighlighter][SyntaxHighlighter]]';

our $core;
our $doneInit;

sub initPlugin {

  $doneInit = 0;
  return 1;
}

sub commonTagsHandler {

  $_[0] =~ s/%CODE(?:_DP)?{(.*?)}%\s*(.*?)%ENDCODE%/&_handleTag($1, $2)/egs;

  return;
}

sub getCore {

  if (defined $core) {
    $core->init unless $doneInit;
  } else {
    require Foswiki::Plugins::DpSyntaxHighlighterPlugin::Core;
    $core = new Foswiki::Plugins::DpSyntaxHighlighterPlugin::Core();
  }

  $doneInit = 1;

  return $core;
}

# handles the tag
sub _handleTag {
  my ($rawParams, $code) = @_;

  my %params = Foswiki::Func::extractParameters($rawParams);

  return getCore()->handleTag(\%params, $code);
}

1;
