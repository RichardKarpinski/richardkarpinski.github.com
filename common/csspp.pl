#!/usr/bin/perl

## first read all the defines...

$ident = qr/[a-z_\-][a-z_0-9\-]*/i;

define: while (<>)
{
  /\S/ or next;
  /^\s*--+\s*$/ and last;
  /^define\b/ or last;
  define: if ( /^define\s+($ident)\s*$/ )
  {
    ## a multi-line define...
    $_{"`$1`"} = $1;
    my $m = $1;
    while (<>)
    {
      /^\s+\S/ or goto define;
      $_{$m} .= $_;
    }
  }
  elsif ( /^\s*define\s+($ident)\s+(.*?)\s*$/ )
  {
    ## a single-line define...
    $_{"`$1`"} = $1;
    $_{$1} = $2;
  }
  else { die "Invalid define: $_" }
}

## construct a regex for finding macro replacements...

push @re, "\\b\Q$_\E\\b|<\Q$_\E>|`\Q$_\E`" for
sort { length $b <=> length $a } keys %_;
$re = join '|', @re; $re = qr[$re];

## and process the rest of the file...

s[($re)][ $1 =~ /(`?$ident`?)/; $_{$1} ]ge, print;
s[($re)][ $1 =~ /(`?$ident`?)/; $_{$1} ]ge, print while <>;
