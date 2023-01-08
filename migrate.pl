#!/bin/perl

my $outputFile="/var/services/homes/Honza/PRIVATE/PEMEDICA/MEDAX.txt";

select(STDERR);
$| = 1;
select(STDOUT); # default
$| = 1;

my $mode=0;
my $RC;
my $fullName;
my $checkType;
my $day=11;
my $month=1;
my $year=2023;

my $outputLine;
my $popis;
my $startTime;
my $endTime;
my $name;
my $RC;
my $delka;

print "$day.$month.$year   Press . to increase or start data input\n";


open(my $FH, ">>", $outputFile) or die "File couldn't be opened";

while(my $line = <>) {
  chomp $line;
  if ( $mode == 0) {
    $outputLine = "";
    if ( $line eq ".") {
      if ( $day++ == 31) {
            $day=1;
            $month++;
      }
      print "$day.$month.$year   Press . to increase or start data input\n";
          next;
        }
        if ( $line =~ /^(\d{2}:\d{2}) - (\d{2}:\d{2})(.*)$/g) {
          $startTime = $1;
          $endTime = $2;
          my $resLine = $3;
          if ( $resLine =~ /Dia/g) {
            $popis = "DIA"
          } else {
            $popis = "INT"
          }

          if ( $resLine =~ /.* (\d+).*/g) {
            $delka = $1;
          } else {
             print "Unresolved DELKA: $resLine\n";
      }

          $mode++;
          next;
        }
    next;
  } elsif ( $mode == 1 ) {
    $name = $line;
    $mode++;
        next;
  } elsif ( $mode == 2 ) {
     if ( $line =~ /^(\d{6}\/\d*)(.*)$/g) {
           $RC =  "$1";
         } else {
           $RC = "000000/0000";
         }

  }

  $outputLine = "$RC,$day.$month.$year,$startTime,$delka,$popis";

  print $FH "$outputLine\n";
  $FH->flush;
  $mode = 0;

}


close(FILE);
