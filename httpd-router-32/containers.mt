RewriteEngine on

% for my $container (@_) {
% if ($container->{Config}{Hostname}) {
# hostname <%= join '.', $container->{Config}{Hostname}, split /\./, $container->{Config}{Domainname} %>
# container <%= substr $container->{Name}, 1 %> (<%= $container->{Id} %>)
# image <%= $container->{Config}{Image} %> (<%= $container->{Image} %>)
% my $hostmatch = join '\.', $container->{Config}{Hostname}, split /\./, $container->{Config}{Domainname};
% $hostmatch =~ s{([A-Za-z])}{'[' . uc($1) . lc($1) . ']'}eg;
RewriteCond %{HTTP_HOST} ^<%= $hostmatch %>$ [OR]
RewriteCond %{ENV:container_host} =<%= $container->{Config}{Hostname} %>
RewriteRule ^(.*) http://<%= $container->{NetworkSettings}{IPAddress} %>/$1 [P]

% }
% }
