import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_forecast_model.dart';

class ForecastScreen extends StatefulWidget {
  final ForecastModel forecast;
  const ForecastScreen({super.key, required this.forecast});

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  @override
  Widget build(BuildContext context) {
    final infoList = widget.forecast.toString().trim().split(",");
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Forecast of ${widget.forecast.date}"),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        children: [
          Card(
            elevation: 6,
            color: theme.colorScheme.primaryContainer,
            child: Image.network(
              "http:${widget.forecast.weatherIcon}",
              scale: 0.4,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 14),
            child: const Text(
              "Summerized Info",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
          ),
          ...infoList.map((e) {
            final info = e.trim().split(": ");
            if (info.length == 2) return InfoRow(info: info[0], value: info[1]);
            return Container();
          }),
        ],
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String info;
  final String value;
  const InfoRow({super.key, required this.info, required this.value});

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontSize: 16,
    );

    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(info, style: textStyle),
          Text(value, style: textStyle),
        ],
      ),
    );
  }
}
