use strict;

# vim: ft=perl sw=4 ts=4

# run this test?
use File::Basename;
require Test::More;

my $test_bn = basename($0);
$test_bn =~ /^\d+-(.*)\.t/;
my $test_name = $1;

open my $config_fh, "<", "test.config";
while(<$config_fh>) {
    if(/^$test_name\s+(.*)/) {
        if(!$1) {
            # dummy test to keep the harness happy
            import Test::More tests => 1;
            ok(1);
            exit;
        }
        
    }
}
close $config_fh;

# now the real tests begin

use Email::Folder::Exchange;
use UNIVERSAL qw(isa);

import Test::More tests => 8;

use_ok('Term::ReadKey');

print STDERR "\n";
print STDERR "URL to test [format: http://site.com/exchange/username/Inbox]: ";
my $url = ReadLine(0);
chomp $url;

print STDERR "Username to authenticate with [format: DOMAIN\\username]: ";
my $username = ReadLine(0);
chomp $username;

print STDERR "Password to authenticate with [will not echo]: ";
ReadMode('noecho');
my $password = ReadLine(0);
chomp $password;
ReadMode('normal');

ok(my $f = Email::Folder::Exchange->new($url, $username, $password), 'login');

ok(my $m = $f->next_message, 'next_message');

ok(isa($m, 'Email::Simple'), 'message_type');

ok(my $f2 = $f->next_folder, 'next_folder');

ok(isa($f2, 'Email::Folder::Exchange'), 'folder_type');

ok(my $m2 = $f->next_message, 'folder_next_message');

ok(isa($m2, 'Email::Simple'), 'message_type');















