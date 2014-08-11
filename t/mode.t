use t::Helper;

{
  my $t = t::Helper->t({ mode => 1 });
  my $sass = $t->app->asset->preprocessors->has_subscribers('sass');
  plan skip_all => 'Could not find preprocessors for sass', 6 unless $sass;
  ok $sass, 'found sass';
}

{
  local $ENV{MOJO_MODE} = 'production';
  my $t = t::Helper->t({ mode => 1 });
  $t->app->asset('app.css' => '/sass/a.sass');
  $t->get_ok('/mode')->content_like(qr{/packed/app-81292545c41544394e4d436682ccf779\.css});
}

{
  local $ENV{MOJO_MODE} = 'development';
  my $t = t::Helper->t({ mode => 1 });
  $t->app->asset('app.css' => '/sass/a.sass');
  $t->get_ok('/mode')->content_like(qr{/packed/app-81292545c41544394e4d436682ccf779-development\.css});
}

done_testing;

__DATA__
@@ mode.html.ep
%= asset 'app.css'
