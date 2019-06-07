package nosey.definition;

typedef DRef<T> = {
	public function get() : T;
	public function toString() : String;
}