#!/usr/bin/env sh

# Colours.
default_fg='rgb:eae89e'
default_bg='rgb:353535'

cursor_fg='rgb:000000'
cursor_bg='rgb:ffffff'

grey_1='rgb:858585'
grey_2='rgb:757575'
grey_3='rgb:666666'
grey_4='rgb:5c5c5c'
grey_5='rgb:525252'
grey_6='rgb:474747'
grey_7='rgb:3d3d3d'
grey_8='rgb:333333'

yellow_1='rgb:f0e333'
yellow_2='rgb:d8cc2e'
yellow_3='rgb:c0b629'
yellow_4='rgb:a89f24'
yellow_5='rgb:90881f'
yellow_6='rgb:78721a'
yellow_7='rgb:605b14'
yellow_8='rgb:48440f'

cream_1='rgb:d8e09a'
cream_2='rgb:d2dc8b'
cream_3='rgb:cdd77d'
cream_4='rgb:c7d36e'
cream_5='rgb:b3be63'
cream_6='rgb:9fa958'
cream_7='rgb:8b944d'
cream_8='rgb:777f42'

echo "# Yuloo
# A yellow colour scheme designed for high contrast on a
# dark screen with a blue light filter active."

# tint a colour
# $1 = hex
# $2 = percentage change (-100 - 100)
tint() {
	echo "import colorsys;hex='$1'[4:];shift=$2;h,s,v=colorsys.rgb_to_hsv(*(int(''.join(x),16)/255 for x in zip(hex[0::2],hex[1::2])));print('rgb:'+''.join(('{0:02x}'.format(x)for x in(min(255, max(round(x*255), 0))for x in colorsys.hsv_to_rgb(h,s,v+(shift/100))))))" | python3
}




# Code.
echo "
face global comment       ${grey_4}
face global documentation ${grey_4}

face global module        ${grey_1}+b
face global meta          ${grey_1}
face global namespace     ${grey_1}

face global identifier    ${cream_6}
face global variable      ${cream_6}
face global attribute     ${cream_6}
face global type          ${cream_6}

face global operator      ${cream_1}+b
face global builtin       ${cream_1}
face global function      ${cream_1}

face global keyword       ${yellow_5}
face global value         ${yellow_5}

face global string        ${yellow_1}
"


# Markdown.
echo "
face global title   ${yellow_1}+b
face global header  ${yellow_1}+b

face global block   ${cream_1}

face global bullet  ${cream_6}
face global list    ${cream_6}

face global link    ${grey_4}

face global mono    ${grey_1}
face global bold    ${grey_1}+b
face global italic  ${grey_1}+i
"


white='rgb:ffffff'
black='rgb:000000'


default_fg=$(tint $white -15)
default_bg=$(tint $black 3)

inactive_fg=$(tint $white -45)
inactive_bg=$(tint $black 0)

black_2=$(tint $black 2)
black_5=$(tint $black 5)
black_7=$(tint $black 7)
black_10=$(tint $black 10)
black_15=$(tint $black 15)
black_20=$(tint $black 20)
black_22=$(tint $black 22)
black_25=$(tint $black 25)
black_30=$(tint $black 30)
black_35=$(tint $black 35)
black_40=$(tint $black 40)
black_45=$(tint $black 45)
black_50=$(tint $black 50)

white_5=$(tint $white -5)
white_10=$(tint $white -10)
white_15=$(tint $white -15)
white_22=$(tint $white -22)
white_20=$(tint $white -20)
white_25=$(tint $white -25)
white_30=$(tint $white -30)
white_35=$(tint $white -35)
white_40=$(tint $white -40)
white_45=$(tint $white -45)
white_50=$(tint $white -50)


# UI.
echo "
face global FocusedLine             default,$black_5
face global Whitespace              $black_10+f

face global BufferPadding           $default_bg,$default_bg

face global PrimarySelection        $black_10,$white_30
face global SecondarySelection      $black_10,$white_50

face global StatusCursor            $black_10,$white_10
face global PrimaryCursor           $black_10,$white_10
face global PrimaryCursorEol        $black_10,$white_10
face global SecondaryCursor         $black_10,$white_30
face global SecondaryCursorEol      $black_10,$white_30

face global LineNumbers             $black_35
face global LineNumberCursor        $black_50

face global MatchingChar            $white_20,$black_20+Fb
face global Search                  $white_45,$black_30

face global MenuBackground          $white,$black_5
face global MenuForeground          $white,$black_10+b
face global MenuInfo                $white,$black_10

face global Default                 $default_fg,$default_bg
face global Error                   $default_fg,$default_bg
face global Prompt                  $default_fg,$default_bg
face global StatusLine              $default_fg,$default_bg
face global StatusLineInfo          $default_fg,$default_bg

face global StatusLineMode          $default_fg,$black_10
face global StatusLineValue         $default_fg,$black_10
face global Information             $default_fg,$black_10
"



echo "
face global InactiveFocusedLine             default,$black_2
face global InactiveWhitespace              $black_5+f

face global InactiveBufferPadding           $inactive_bg,$inactive_bg

face global InactivePrimarySelection        $black_5,$white_15
face global InactiveSecondarySelection      $black_5,$white_25

face global InactiveStatusCursor            $black_5,$white_5
face global InactivePrimaryCursor           $black_5,$white_5
face global InactivePrimaryCursorEol        $black_5,$white_5
face global InactiveSecondaryCursor         $black_5,$white_15
face global InactiveSecondaryCursorEol      $black_5,$white_15

face global InactiveLineNumbers             $black_7
face global InactiveLineNumberCursor        $black_15

face global InactiveMatchingChar            $white_10,$black_10+Fb
face global InactiveSearch                  $white_22,$black_15

face global InactiveMenuBackground          $white,$black_2
face global InactiveMenuForeground          $white,$black_5+b
face global InactiveMenuInfo                $white,$black_5

face global InactiveDefault                 $default_fg,$inactive_bg
face global InactiveError                   $inactive_fg,$inactive_bg
face global InactivePrompt                  $inactive_fg,$inactive_bg
face global InactiveStatusLine              $inactive_fg,$inactive_bg
face global InactiveStatusLineInfo          $inactive_fg,$inactive_bg

face global InactiveStatusLineMode          $inactive_fg,$black_5
face global InactiveStatusLineValue         $inactive_fg,$black_5
face global InactiveInformation             $inactive_fg,$black_5
"



