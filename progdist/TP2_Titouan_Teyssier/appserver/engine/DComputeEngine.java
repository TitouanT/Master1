package engine;

public class DComputeEngine implements ComputeEngine {

	public <T> T execute(TaskDescriptor<T> td) {
		T res = td.getTask().execute();
		td.setResult(res);
		return res;
	}

}
