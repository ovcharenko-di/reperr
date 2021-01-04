FROM evilbeaver/onescript:1.4.0

COPY src /app
WORKDIR /app
RUN opm install opm && opm install -l

FROM evilbeaver/oscript-web:0.7.0
COPY --from=0 /app .