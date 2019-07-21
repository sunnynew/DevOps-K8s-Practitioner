Configure Grafana dashboard using Prometheus metrics
----------------------------------------------------
1). Get Prometheus service endpoint

- kubectl get service/prometheus-server -n monitoring

2). Open Grafana

3). Click on the Grafana logo to open the sidebar menu.

4). Click on "Data Sources" in the sidebar.

5). Click on "Add New".

6). Select "Prometheus" as the type.

7). Set the appropriate Prometheus server URL (use URL you get from step 1, CLUSTER-IP:PORT)

8). Click "Add" to save the new data source.


Import Grafana Dashboard
------------------------
I used https://grafana.com/grafana/dashboards/8588
