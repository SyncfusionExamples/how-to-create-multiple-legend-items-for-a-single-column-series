import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_charts/src/charts/common/core_legend.dart';

void main() {
  return runApp(const ChartApp());
}

class ChartApp extends StatelessWidget {
  const ChartApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: false),
      home: const _MyHomePage(),
    );
  }
}

class _MyHomePage extends StatefulWidget {
  const _MyHomePage();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<_MyHomePage> {
  List<_SalesData> data = [
    _SalesData('Jan', 35),
    _SalesData('Oct', -35),
    _SalesData('Feb', 28),
    _SalesData('Aug', -34),
    _SalesData('Mar', 34),
    _SalesData('July', -32),
    _SalesData('Apr', 32),
    _SalesData('Jun', -40),
    _SalesData('May', 40),
    _SalesData('Sep', -28),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfCartesianChart(
        primaryXAxis: const CategoryAxis(),
        title: const ChartTitle(text: 'Half yearly sales analysis'),
        legend: const Legend(isVisible: true),
        series: <CartesianSeries<_SalesData, String>>[
          ColumnSeries<_SalesData, String>(
            dataSource: data,
            xValueMapper: (_SalesData sales, _) => sales.year,
            yValueMapper: (_SalesData sales, _) => sales.sales,
            pointColorMapper: (_SalesData sales, _) =>
                sales.sales.isNegative ? Colors.red : Colors.green,
            name: 'Sales',
            onCreateRenderer: (series) {
              return CustomColumnSeriesRenderer();
            },
          )
        ],
      ),
    );
  }
}

class CustomColumnSeriesRenderer<T, D> extends ColumnSeriesRenderer<T, D> {
  CustomColumnSeriesRenderer();

  bool isToggled = false;
  List<String> legendText = ['Positive', 'Negative'];
  List<Color> iconPalette = [Colors.green, Colors.red];

  @override
  List<LegendItem>? buildLegendItems(int index) {
    List<LegendItem> items = <LegendItem>[];
    int i = 0;
    for (i; i < 2; i++) {
      LegendItem item = LegendItem(
          text: legendText[i],
          iconType: ShapeMarkerType.rectangle,
          iconColor: iconPalette[i],
          onTap: _handleLegendItemTapped,
          iconBorderWidth: 1);
      items.add(item);
    }
    return items;
  }

  void _handleLegendItemTapped(LegendItem item, bool isToggled) {
    for (int i = 0; i < segments.length; i++) {
      ColumnSegment segment = segments[i] as ColumnSegment;
      bool isPositive = item.text == 'Positive' && !segment.y.isNegative;
      bool isNegative = item.text == 'Negative' && segment.y.isNegative;
      if (isPositive) {
        segment.isVisible = !isToggled;
      } else if (isNegative) {
        segment.isVisible = !isToggled;
      }
      if (segment.isVisible == !isPositive) {
        item.onToggled?.call();
      }
      if (segment.isVisible == !isNegative) {
        item.onToggled?.call();
      }
    }

    markNeedsUpdate();
  }

  @override
  ColumnSegment<T, D> createSegment() {
    return CustomColumnSegment<T, D>();
  }
}

class CustomColumnSegment<T, D> extends ColumnSegment<T, D> {
  CustomColumnSegment();

  @override
  void transformValues() {
    if (!series.segmentAt(currentSegmentIndex).isVisible) {
      return;
    }
    super.transformValues();
  }

  @override
  void onPaint(Canvas canvas) {
    if (!series.segmentAt(currentSegmentIndex).isVisible) {
      return;
    }
    super.onPaint(canvas);
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
