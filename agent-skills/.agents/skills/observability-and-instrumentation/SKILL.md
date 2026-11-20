---
name: observability-and-instrumentation
description: Make production behaviour visible and diagnosable with logs, metrics, traces, and alerts. Use when adding or changing instrumentation, logging, metrics, tracing, dashboards, or alert rules, or when asked to make a service, job, or integration observable; not for diagnosing a live failure or for features that do not touch telemetry.
---

# Observability and instrumentation

Instrument so an on-call engineer can tell whether something works and why it does not, without reading the source. Every signal should answer a question; telemetry without one is cost and noise.

## Start from on-call questions

Write down the few questions someone will ask about this code in an incident, for example: are deliveries succeeding, which failure class is growing, is the dependency slower, which entry point started this run. Read what the repository already emits and how (logger, metrics library, naming, label conventions, trace setup), and extend that rather than adding a parallel system.

Choose the signal per question: metrics for how often and how fast in aggregate, logs for what happened in one case, traces for where time went across calls.

## Metrics

- Cover rate, errors, and duration for each endpoint, job, and external dependency; for queues and pools, cover utilization, saturation, and errors. Count retries and final outcomes separately, so retried success is distinguishable from first-try success.
- Record latency in histograms with buckets that bracket the expected range and the alert threshold, never as an average.
- Keep labels to small, fixed sets: route templates, method, status class, outcome or error class, dependency name. Never use IDs of customers, services, or requests, raw paths or URLs, error message text, or other unbounded values; those belong in logs and traces. Estimate the series count from the label sets against real scale.
- Follow the ecosystem's naming conventions (for Prometheus, base units and suffixes such as `_seconds` and `_total`) and register on the registry the code is given, not a global one.

## Logs

- Emit structured events with a stable message and machine-readable fields through the project's logger, at levels that mean something: errors need action, warnings are handled degradation, info is a significant event, debug is off in production.
- Include what correlates the event (request, run, or event ID), the entry point when several paths write the same log, and the attempt or outcome.
- Never log secrets, credentials, authorization headers, tokens embedded in URLs, or personal data. Allowlist fields instead of logging whole requests, bodies, or URLs; redact or reduce a URL to its host when it may carry secrets.
- Do not log every success at high volume when a metric already counts it.

## Traces and alerts

Propagate trace context across every call and async boundary you touch, and add spans only around meaningful units of work, with attributes on-call will filter by. Alert on symptoms users feel (error ratio, latency, backlog age) with a threshold and duration justified by an objective or data, and a short runbook: what it means, the first query to run, and who to escalate to. Cause-only signals such as CPU belong on dashboards.

## Verify the telemetry

Instrumentation is code. Exercise success, retry, and failure paths in a test, then assert on the emitted metrics and log output: the expected series and labels exist, cardinality stays bounded under many distinct IDs, and nothing secret appears. Report the questions each signal answers, the series and estimated cardinality, and anything you could not verify, such as dashboards or alert routing.
