RewriteEngine on

% sub get_gateway {
%     my $routes = qx{netstat -r -n};
%     $routes =~ m{^0\.0\.0\.0\s+(\S+)}m and return $1;
% }
%
% for my $container (@_) {
% if ($container->{Config}{Hostname}) {
% my $full_hostname = $container->{Env}{PUBLIC_HTTP_HOST} || join '.', $container->{Config}{Hostname}, split /\./, $container->{Config}{Domainname};
% my ($short_hostname) = split /\./, $full_hostname;
% my $escaped_hostname = $full_hostname;
% $escaped_hostname =~ s{\.}{\\.}g;
# hostname <%= $full_hostname %>
# container <%= substr $container->{Name}, 1 %> (<%= $container->{Id} %>)
# image <%= $container->{Config}{Image} %> (<%= $container->{Image} %>)
RewriteCond %{HTTP_HOST} ^<%= $escaped_hostname %>$ [NC,OR]
RewriteCond %{ENV:container_host} =<%= $short_hostname %>
RewriteRule ^(.*) http://<%= $container->{NetworkSettings}{IPAddress} || get_gateway() %>:<%= $container->{Env}{PUBLIC_HTTP_PORT} || 80 %>/$1 [P]

% }
% }
