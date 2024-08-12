import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:ui' as ui;
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
    _SalesData('Feb', -35),
    _SalesData('Mar', 28),
    _SalesData('Apr', -34),
    _SalesData('May', 34),
    _SalesData('Jun', -32),
    _SalesData('July', 32),
    _SalesData('Aug', -40),
    _SalesData('Sep', 40),
    _SalesData('Oct', -28),
    _SalesData('Nov', 30),
    _SalesData('Dec', -38),
  ];
  double _midValue = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfCartesianChart(
        primaryXAxis: const CategoryAxis(),
        legend: const Legend(isVisible: true),
        onActualRangeChanged: (ActualRangeChangedArgs rangeChangedArgs) {
          if (rangeChangedArgs.orientation == AxisOrientation.vertical) {
            _midValue = rangeChangedArgs.visibleMax /
                (rangeChangedArgs.visibleMax.abs() +
                    rangeChangedArgs.visibleMin.abs());
          }
        },
        series: <CartesianSeries<_SalesData, String>>[
          ColumnSeries<_SalesData, String>(
            dataSource: data,
            xValueMapper: (_SalesData data, _) => data.year,
            yValueMapper: (_SalesData data, _) => data.sales,
            color: Colors.green.withOpacity(0.4),
            onCreateShader: (ShaderDetails details) {
              return ui.Gradient.linear(
                details.rect.topCenter,
                details.rect.bottomCenter,
                <Color>[
                  Colors.green,
                  Colors.green,
                  Colors.red,
                  Colors.red,
                ],
                <double>[
                  0,
                  _midValue,
                  _midValue,
                  1,
                ],
              );
            },
            borderColor: Colors.green,
            onCreateRenderer: (series) {
              return _CustomColumnSeriesRenderer();
            },
          ),
        ],
      ),
    );
  }
}

class _CustomColumnSeriesRenderer<T, D> extends ColumnSeriesRenderer<T, D> {
  _CustomColumnSeriesRenderer();

  final List<String> _legendText = ['Positive', 'Negative'];
  final List<Color> _iconPalette = [Colors.green, Colors.red];
  bool positiveVisible = true;
  bool negativeVisible = true;

  @override
  List<LegendItem>? buildLegendItems(int index) {
    return List<LegendItem>.generate(_legendText.length, (i) {
      return LegendItem(
        text: _legendText[i],
        iconType: ShapeMarkerType.rectangle,
        iconColor: _iconPalette[i],
        onTap: (LegendItem item, bool isToggled) {
          _handleLegendItemTapped(i);
        },
        iconBorderWidth: 1,
      );
    });
  }

  void _handleLegendItemTapped(int index) {
    if (index == 0) {
      positiveVisible = !positiveVisible;
    } else if (index == 1) {
      negativeVisible = !negativeVisible;
    }

    for (ChartSegment segment in segments) {
      ColumnSegment segmentTyped = segment as ColumnSegment;
      if (segmentTyped.y.isNegative) {
        segmentTyped.isVisible = negativeVisible;
      } else {
        segmentTyped.isVisible = positiveVisible;
      }
    }

    markNeedsUpdate();
  }

  @override
  ColumnSegment<T, D> createSegment() {
    return _CustomColumnSegment<T, D>();
  }
}

class _CustomColumnSegment<T, D> extends ColumnSegment<T, D> {
  _CustomColumnSegment();

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
