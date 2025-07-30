package engine;

import java.util.Calendar;

public class TComputeEngine extends ComputeEngineNotifier {
	final int delay = -1;

	public TComputeEngine() {
		super();
	}

	@SuppressWarnings("unchecked")
	public void run() {
		while(true) {
			try {
				Thread.sleep(20);

				if (!tds.isEmpty()) {
					TaskDescriptor td = tds.peek();
					int diff = td.getTime().get(Calendar.MINUTE) - Calendar.getInstance().get(Calendar.MINUTE);
					if (diff > 0) continue;

					if (diff <= delay) {
						System.out.println("la tâche est expirée");
					} else {
						td.setResult(td.getTask().execute());
						tn.addTaskObserver(td);
					}
					tds.remove(td);
				}
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
	}
}
