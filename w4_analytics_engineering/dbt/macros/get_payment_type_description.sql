{# This macro returns the description of the payment type #}

{% macro get_payment_type_description(payment_type) %}

    CASE cast(payment_type as integer)
        WHEN 1 THEN 'Credit card'
        WHEN 2 THEN 'Cash'
        WHEN 3 THEN 'No charge'
        WHEN 4 THEN 'Dispute'
        WHEN 5 THEN 'Unknown'
        WHEN 6 THEN 'Voided trip'
END

{% endmacro%}