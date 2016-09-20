package ru.bmstu.rk9.rao.lib.result;

import ru.bmstu.rk9.rao.lib.json.JSONObject;

public class WeightedStorelessNumericStatistics<T extends Number> extends Statistics<T> {

	@Override
	public void updateData(JSONObject data) {
		addValue(lastValue, lastCurrentTime);
		data.put("Mean", getMean());
		data.put("Standard deviation", getStandartDeviation());
		data.put("varcoef", getCoefficientOfVariation());
		data.put("Median", getMedian());
	}

	@Override
	public void update(T value, double currentTime) {
		double nextValue = value.doubleValue();
		if (lastValue != nextValue) {
			addValue(nextValue, currentTime);
		}
		lastValue = nextValue;
		lastCurrentTime = currentTime;
	}

	private boolean started = false;

	private double lastValue;

	private double lastWeight;

	private double lastCurrentTime;

	private double weightSum;

	private double mean;

	private double variance;

	private void addValue(double nextValue, double nextWeight) {
		if (started) {
			double x = lastValue;
			double weight = nextWeight - lastWeight;

			if (weight != 0) {
				double lastMean = mean;

				weightSum += weight;

				mean = weight / weightSum * (x - lastMean) + lastMean;
				variance = variance + weight * (x - lastMean) * (x - mean);
			}
		} else {
			mean = 0;
			weightSum = 0;
			variance = 0;

			started = true;
		}

		lastWeight = nextWeight;
	}

	private double getMean() {
		return mean;
	}

	private double getStandartDeviation() {
		return Math.sqrt(variance / weightSum);
	}

	private double getCoefficientOfVariation() {
		return variance / weightSum / mean * 100d;
	}

	private double median;

	private double getMedian() {
		return median;
	}
}