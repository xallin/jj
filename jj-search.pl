#! /usr/bin/perl -w

# @xallin - 2017-05-07 - v1.0
# Search and display journal entries from Journal folder

# Modules and configuration
use Text::Wrap;
use Getopt::Long;
$Text::Wrap::columns = 78;
Getopt::Long::Configure ("bundling");

# Programm options variables
my $from="";
my $to="";
my @exclude=();
my $wtag="";
my $short="";
my $number=0;
my $or="";
my $help="";
my $export="";

# Options parsing
GetOptions ("from|f=s" => \$from,    
              "to|t=s"   => \$to,      
              "exclude|e=s"  => \@exclude,
			  "wtag|w" => \$wtag,
			  "short|s" => \$short,
			  "number|n=i" => \$number,
			  "or|o" => \$or,
			  "help|h|?" => \$help,
			  "export" => \$export
  or die("Error in command line arguments\n");

# help option
if ($help) {
  print "\n";
  print "jj-search.pl: Search in journal entries\n";
  print "Version 1.0 - 2017-05-07\n";
  print "Usage: jj-search.pl [options] [searches]\n";
  print "Options:\n";
  print "  --from, -f yyyy-mm-dd     :from date\n";
  print "  --to, -t yyyy-mm-dd       :to date\n";
  print "  --exclude, -e word(s)     :exclude tag(s) or term(s)\n";
  print "  --number, -n integrer     :print last number specified entries\n";
  print "  --or, -o                  :OR mode for arguments (default AND)\n";
  print "  --wtag, -w                :without \@tag entries\n";
  print "  --short, -s               :short prints only entries' title\n";
  print "  --export                  :print without wrapping and with md headers\n";
  print "Arguments after options: for searching one or several regex words\n";
  print "\n";
  exit 255;
}

@output=();

# TO BE DEFINED

FILE: foreach $file (<"/path/to/journal/folder/*.txt">) {

  # Filter -f option
  if ($from) {
	$fdate = substr $file, -20, 10;
	if (! ($fdate ge $from)) {next;}
  }

  # Filter -t option
  if ($to) {
	$tdate = substr $file, -20, 10;
	if (! ($tdate le $to)) {next;}
  }

  # Get all content of the entry after date filtered
  open(my $entry, $file) 
	or die("Can't open the file");
  my $all = do {local $/; <$entry>}; # $all = entry all content
  close($entry);
  
  # Filter -w without tag
  if ($wtag) {
	if ($all =~ m/(\s)+\@(\S)+/) {next;}
  }

  # Filter -e exclude
  if (@exclude) {
	foreach $ex (@exclude) {
	  if ($all =~ m/$ex/il) {next FILE;}
	}
  }

  # Filter other arguments in ARGV
  
  if ($or and (@ARGV > 1)) { # OR mode enabled 
	foreach $arg (@ARGV) {
	  if (! ($all =~ m/$arg/il)) {next;}
	  else {
		# Add filtred entry in case with arg, after each OK arg loop
		push @output, $all;
		next FILE; # no multiple same entry
	  }
	}

  } else { # AND mode
	if (@ARGV > 0) {
	  foreach $arg (@ARGV) {
		if (! ($all =~ m/$arg/il)) {next FILE;}
	  }
	}
  # Add filtred entry to output after arg loop
	push @output, $all;
  }
    
# Print output

$length = scalar @output;

if ($number and ($number < $length)) { # number argument specified
  if ($short) {
	  for ($i=($length-$number); $i < $length; $i++) {
		$title=(split /\n/, $output[$i])[0];
		print "$title\n";
	  }
    }
  elsif ($export) { # for export in file
	for ($i=($length-$number); $i < $length; $i++) {
	  print '#### '.$output[$i];
	}
  } else {
	for ($i=($length-$number); $i < $length; $i++) {
	  print wrap('  ', '  ', $output[$i]);
	  print "\n";
	}
  }
} else { # without number argument
  if ($short) {
	foreach (@output) {
	  $title=(split /\n/, $_)[0];
	  print "$title\n";
	}
  }
  elsif ($export) { # for export in file
	foreach (@output) {
	  print '#### '.$_;
	}
  } else {
	foreach (@output) {
	  print wrap('  ', '  ', $_);
	  print "\n";
	}
  }
}

# end of file
