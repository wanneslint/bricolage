package Bric::Util::Fault::Exception;
use Bric::Util::Fault;

1;
__END__

=head1 NAME

Bric::Util::Fault::Exception - Legacy Exception Class

=head1 DESCRIPTION

This is a dummy class to keep Bricolage from breaking when various classes and
libraries C<use Bric::Util::Fault::Exception>. Eventually all such use
statements will be removed and we'll be able to delete this file, as all
exceptions are now handled internally by L<Bric::Util::Fault|Bric::Util::Fault>.

=cut
