{% if theme.mta_analytics.enable === true %}
    <script src="//pingjs.qq.com/h5/stats.js?v2.0.4"
        name={{theme.mta_analytics.name}}
        sid={{theme.mta_analytics.sid}}></script>
{% endif %}